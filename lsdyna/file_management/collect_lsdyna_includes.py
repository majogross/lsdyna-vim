#!/usr/bin/env python3
"""
LS-DYNA Include File Collector

This script processes LS-DYNA input decks and collects all referenced include files
into a centralized subdirectory. It handles *INCLUDE_PATH and *INCLUDE keywords,
resolves file paths, and generates a modified main deck with updated references.

LS-DYNA Keyword Reference:
- *INCLUDE_PATH: Defines search directories for include files
- *INCLUDE: References another input file to be included inline

Author: Generated for LS-DYNA preprocessing
"""

import os
import sys
import argparse
import shutil
import re
from pathlib import Path
from typing import List, Set, Dict, Tuple


class LSDynaIncludeCollector:
    """Collects and centralizes LS-DYNA include files."""
    
    def __init__(self, main_deck_path: str, output_dir: str = "/proj/cae_muc/q667207/70_scripts/lsdyna_includes"):
        """
        Initialize the collector.
        
        Args:
            main_deck_path: Path to the main LS-DYNA input deck
            output_dir: Path to the output directory (default: /proj/cae_muc/q667207/70_scripts/lsdyna_includes)
        """
        self.main_deck_path = Path(main_deck_path).resolve()
        if not self.main_deck_path.exists():
            raise FileNotFoundError(f"Main deck file not found: {main_deck_path}")
        
        self.main_deck_dir = self.main_deck_path.parent
        # If output_dir is absolute, use it directly; otherwise, treat as relative to main deck
        if os.path.isabs(output_dir):
            self.output_dir = Path(output_dir)
            self.output_dir_name = self.output_dir.name
        else:
            self.output_dir = self.main_deck_dir / output_dir
            self.output_dir_name = output_dir
        
        # Storage for parsed data
        self.include_paths: List[Path] = []
        self.found_includes: Dict[str, Path] = {}
        self.copied_files: Dict[Path, str] = {}
        self.processed_files: Set[Path] = set()
        self.filename_counter: Dict[str, int] = {}
        
    def parse_include_keywords(self, file_path: Path) -> Tuple[List[str], List[str]]:
        """
        Parse *INCLUDE_PATH and *INCLUDE keywords from an LS-DYNA deck.
        
        LS-DYNA uses line-based keyword format where keywords start with *.
        Keywords are case-insensitive. The file path follows the keyword,
        either on the same line or the next line.
        
        Args:
            file_path: Path to the deck file to parse
            
        Returns:
            Tuple of (include_paths, include_files)
        """
        include_paths = []
        include_files = []
        
        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                lines = f.readlines()
                
            i = 0
            while i < len(lines):
                line = lines[i].strip()
                upper_line = line.upper()
                
                # Check for *INCLUDE_PATH keyword
                if upper_line.startswith('*INCLUDE_PATH'):
                    # Extract path from same line or next line
                    path_str = line[13:].strip() if len(line) > 13 else ""
                    
                    if not path_str and i + 1 < len(lines):
                        path_str = lines[i + 1].strip()
                        i += 1
                    
                    if path_str and not path_str.startswith('*'):
                        include_paths.append(path_str)
                
                # Check for *INCLUDE keyword (but not *INCLUDE_PATH)
                elif upper_line.startswith('*INCLUDE') and not upper_line.startswith('*INCLUDE_PATH'):
                    # Extract filename from same line or next line
                    file_str = line[8:].strip() if len(line) > 8 else ""
                    
                    if not file_str and i + 1 < len(lines):
                        file_str = lines[i + 1].strip()
                        i += 1
                    
                    if file_str and not file_str.startswith('*'):
                        include_files.append(file_str)
                
                i += 1
                
        except Exception as e:
            print(f"Warning: Error parsing {file_path}: {e}")
        
        return include_paths, include_files
    
    def resolve_include_path(self, include_ref: str, current_file_dir: Path) -> Path:
        """
        Resolve an include file reference to an actual file path.
        
        Search order:
        1. Relative to current file directory
        2. Relative to main deck directory
        3. In defined include paths
        4. Absolute path
        
        Args:
            include_ref: The include file reference string
            current_file_dir: Directory of the file containing the include
            
        Returns:
            Resolved Path object
            
        Raises:
            FileNotFoundError: If the file cannot be found
        """
        # Try as absolute path first
        if os.path.isabs(include_ref):
            candidate = Path(include_ref)
            if candidate.exists():
                return candidate.resolve()
        
        # Try relative to current file directory
        candidate = current_file_dir / include_ref
        if candidate.exists():
            return candidate.resolve()
        
        # Try relative to main deck directory
        candidate = self.main_deck_dir / include_ref
        if candidate.exists():
            return candidate.resolve()
        
        # Try in each include path
        for include_path in self.include_paths:
            candidate = include_path / include_ref
            if candidate.exists():
                return candidate.resolve()
        
        raise FileNotFoundError(f"Could not resolve include file: {include_ref}")
    
    def get_unique_filename(self, original_path: Path) -> str:
        """
        Generate a unique filename for the output directory.
        Handles duplicates by appending numbers.
        
        Args:
            original_path: Original file path
            
        Returns:
            Unique filename string
        """
        base_name = original_path.name
        
        if base_name not in self.filename_counter:
            self.filename_counter[base_name] = 0
            return base_name
        
        # File exists, append counter
        self.filename_counter[base_name] += 1
        name_parts = original_path.stem, original_path.suffix
        return f"{name_parts[0]}_{self.filename_counter[base_name]}{name_parts[1]}"
    
    def process_file_recursively(self, file_path: Path, current_dir: Path):
        """
        Recursively process a file and all its includes.
        
        Args:
            file_path: Path to the file to process
            current_dir: Directory context for relative path resolution
        """
        # Avoid processing the same file twice (circular includes)
        if file_path in self.processed_files:
            return
        
        self.processed_files.add(file_path)
        
        # Parse this file for include paths and includes
        local_paths, includes = self.parse_include_keywords(file_path)
        
        # Add any new include paths (resolve relative to this file's directory)
        for path_str in local_paths:
            path_obj = Path(path_str)
            if not path_obj.is_absolute():
                path_obj = (file_path.parent / path_obj).resolve()
            
            if path_obj.exists() and path_obj not in self.include_paths:
                self.include_paths.append(path_obj)
        
        # Process each include
        for include_ref in includes:
            try:
                resolved_path = self.resolve_include_path(include_ref, file_path.parent)
                
                # Store the mapping
                if include_ref not in self.found_includes:
                    self.found_includes[include_ref] = resolved_path
                
                # Recursively process this include
                self.process_file_recursively(resolved_path, resolved_path.parent)
                
            except FileNotFoundError as e:
                print(f"Warning: {e}")
    
    def collect_includes(self):
        """
        Main method to collect all includes from the main deck.
        """
        print(f"Processing main deck: {self.main_deck_path}")
        
        # Start recursive processing from main deck
        self.process_file_recursively(self.main_deck_path, self.main_deck_dir)
        
        print(f"Found {len(self.found_includes)} include file(s)")
    
    def copy_files(self):
        """
        Copy all found include files to the output directory.
        """
        # Create output directory
        self.output_dir.mkdir(exist_ok=True)
        print(f"Created output directory: {self.output_dir}")
        
        # Copy each unique file
        for include_ref, source_path in self.found_includes.items():
            if source_path not in self.copied_files:
                dest_filename = self.get_unique_filename(source_path)
                dest_path = self.output_dir / dest_filename
                
                try:
                    shutil.copy2(source_path, dest_path)
                    self.copied_files[source_path] = dest_filename
                    print(f"Copied: {source_path.name} -> {self.output_dir_name}/{dest_filename}")
                except Exception as e:
                    print(f"Error copying {source_path}: {e}")
    
    def generate_modified_deck(self) -> str:
        """
        Generate a modified main deck with updated include references.
        
        Returns:
            Path to the new modified deck file
        """
        output_deck_path = self.output_dir / f"{self.main_deck_path.stem}_modified{self.main_deck_path.suffix}"
        
        try:
            with open(self.main_deck_path, 'r', encoding='utf-8', errors='ignore') as f:
                lines = f.readlines()
            
            modified_lines = []
            i = 0
            
            while i < len(lines):
                line = lines[i]
                upper_line = line.strip().upper()
                
                # Check for *INCLUDE_PATH - remove these lines
                if upper_line.startswith('*INCLUDE_PATH'):
                    # Skip this line and potentially the next line with the path
                    if len(line.strip()) <= 13 and i + 1 < len(lines):
                        i += 1  # Skip the path line too
                    i += 1
                    continue
                
                # Check for *INCLUDE keyword
                if upper_line.startswith('*INCLUDE') and not upper_line.startswith('*INCLUDE_PATH'):
                    modified_lines.append(line)
                    
                    # Check if include file is on the same line
                    include_ref = line.strip()[8:].strip() if len(line.strip()) > 8 else ""
                    
                    # If not on same line, get from next line
                    if not include_ref and i + 1 < len(lines):
                        i += 1
                        include_ref = lines[i].strip()
                    
                    # Replace the include path with the new centralized path
                    if include_ref and not include_ref.startswith('*'):
                        if include_ref in self.found_includes:
                            source_path = self.found_includes[include_ref]
                            if source_path in self.copied_files:
                                new_ref = self.copied_files[source_path]
                                modified_lines.append(f"{new_ref}\n")
                                i += 1
                                continue
                    
                    i += 1
                    continue
                
                # Keep all other lines as-is
                modified_lines.append(line)
                i += 1
            
            # Write modified deck
            with open(output_deck_path, 'w', encoding='utf-8') as f:
                f.writelines(modified_lines)
            
            print(f"Generated modified deck: {output_deck_path}")
            return str(output_deck_path)
            
        except Exception as e:
            print(f"Error generating modified deck: {e}")
            raise
    
    def run(self):
        """Execute the full collection process."""
        try:
            self.collect_includes()
            self.copy_files()
            modified_deck = self.generate_modified_deck()
            
            print("\nSummary:")
            print(f"  Include files found: {len(self.found_includes)}")
            print(f"  Files copied: {len(self.copied_files)}")
            print(f"  Output directory: {self.output_dir}")
            print(f"  Modified deck: {modified_deck}")
            print("\nSuccess! All includes collected.")
            
        except Exception as e:
            print(f"\nError during collection: {e}")
            raise


def main():
    """Main entry point for command-line usage."""
    parser = argparse.ArgumentParser(
        description='Collect LS-DYNA include files into a centralized directory',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Example usage:
  /proj/cae_muc/q667207/70_scripts/lsdyna/file_management/collect_lsdyna_includes.py main_deck.k
  /proj/cae_muc/q667207/70_scripts/lsdyna/file_management/collect_lsdyna_includes.py main_deck.k --output-dir /custom/path
  /proj/cae_muc/q667207/70_scripts/lsdyna/file_management/collect_lsdyna_includes.py main_deck.k --output-dir includes
  
This script will:
  1. Parse the main deck for *INCLUDE_PATH and *INCLUDE keywords
  2. Recursively find all referenced include files
  3. Copy all includes to the output directory (default: /proj/cae_muc/q667207/70_scripts/lsdyna_includes)
  4. Generate a modified main deck with updated references
        """
    )
    
    parser.add_argument(
        'main_deck',
        help='Path to the main LS-DYNA input deck file'
    )
    
    parser.add_argument(
        '--output-dir',
        default='/proj/cae_muc/q667207/70_scripts/lsdyna_includes',
        help='Output directory path (default: /proj/cae_muc/q667207/70_scripts/lsdyna_includes). Can be absolute or relative to main deck location.'
    )
    
    args = parser.parse_args()
    
    try:
        collector = LSDynaIncludeCollector(args.main_deck, args.output_dir)
        collector.run()
        return 0
    
    except FileNotFoundError as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1
    
    except Exception as e:
        print(f"Unexpected error: {e}", file=sys.stderr)
        return 2


if __name__ == '__main__':
    sys.exit(main())