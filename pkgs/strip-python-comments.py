#!/usr/bin/env python3

import ast
import os
import sys
from pathlib import Path
from typing import Any, List

class CommentStripper(ast.NodeTransformer):
    """AST transformer that removes docstrings and comments from Python code."""

    def visit_FunctionDef(self, node: ast.FunctionDef) -> Any:
        """Remove docstrings from function definitions."""
        self._remove_docstring(node)
        return self.generic_visit(node)

    def visit_AsyncFunctionDef(self, node: ast.AsyncFunctionDef) -> Any:
        """Remove docstrings from async function definitions."""
        self._remove_docstring(node)
        return self.generic_visit(node)

    def visit_ClassDef(self, node: ast.ClassDef) -> Any:
        """Remove docstrings from class definitions."""
        self._remove_docstring(node)
        return self.generic_visit(node)

    def visit_Module(self, node: ast.Module) -> Any:
        """Remove module-level docstrings."""
        self._remove_docstring(node)
        return self.generic_visit(node)

    def _remove_docstring(self, node: ast.AST) -> None:
        """Remove the first string literal (docstring) from a node's body."""
        if hasattr(node, "body") and node.body:
            first_stmt = node.body[0]
            if (
                isinstance(first_stmt, ast.Expr)
                and isinstance(first_stmt.value, ast.Constant)
                and isinstance(first_stmt.value.value, str)
            ):
                node.body.pop(0)


def strip_python_file(input_file: str, output_file: str = None, in_place: bool = False) -> str:
    """
    Strip comments and docstrings from a Python file.

    Args:
        input_file: Path to input Python file
        output_file: Path to output file (if None and in_place=False, returns as string)
        in_place: If True, replace the input file with stripped version

    Returns:
        Stripped Python code as string
    """
    with open(input_file, "r", encoding="utf-8") as f:
        source_code = f.read()

    # Extract shebang line if present
    shebang = ""
    lines = source_code.split('\n', 1)
    if lines and lines[0].startswith('#!'):
        shebang = lines[0] + '\n'
        # Remove shebang for AST parsing
        source_code = lines[1] if len(lines) > 1 else ""

    # Parse the source code into an AST
    tree = ast.parse(source_code)

    # Transform the AST to remove docstrings
    stripper = CommentStripper()
    stripped_tree = stripper.visit(tree)

    # Convert back to source code
    stripped_code = ast.unparse(stripped_tree)

    # Prepend shebang if it was present
    if shebang:
        stripped_code = shebang + stripped_code

    if output_file:
        with open(output_file, "w", encoding="utf-8") as f:
            f.write(stripped_code)
    elif in_place:
        with open(input_file, "w", encoding="utf-8") as f:
            f.write(stripped_code)

    return stripped_code


def find_python_files(directory: str) -> List[str]:
    """
    Recursively find all Python files in a directory.

    Args:
        directory: Path to directory to search

    Returns:
        List of Python file paths
    """
    python_files = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.py'):
                python_files.append(os.path.join(root, file))
    return python_files


def main():
    """Main function to handle command line arguments."""
    if len(sys.argv) < 2:
        print("Usage: python stripdoc.py <input_file_or_directory> [output_file]")
        print("       python stripdoc.py <input_file>  (replaces file in-place)")
        print("       python stripdoc.py <directory>   (processes all .py files in-place)")
        sys.exit(1)

    input_path = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None

    try:
        if os.path.isdir(input_path):
            # Process directory
            if output_file:
                print("Error: Output file cannot be specified when processing a directory")
                sys.exit(1)

            python_files = find_python_files(input_path)
            if not python_files:
                print(f"No Python files found in directory '{input_path}'")
                return

            print(f"Found {len(python_files)} Python file(s) in '{input_path}'")
            for file_path in python_files:
                try:
                    strip_python_file(file_path, None, True)
                    print(f"Stripped: {file_path}")
                except Exception as e:
                    print(f"Error processing {file_path}: {e}")

        elif os.path.isfile(input_path):
            # Process single file
            in_place = output_file is None
            stripped_code = strip_python_file(input_path, output_file, in_place)

            if in_place:
                print(f"File '{input_path}' has been stripped in-place")
            elif output_file:
                print(f"Stripped code written to {output_file}")
            else:
                print(stripped_code)
        else:
            print(f"Error: '{input_path}' is not a valid file or directory")
            sys.exit(1)

    except FileNotFoundError:
        print(f"Error: Path '{input_path}' not found")
        sys.exit(1)
    except SyntaxError as e:
        print(f"Error: Invalid Python syntax: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
