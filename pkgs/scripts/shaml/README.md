## shaml

shaml is a micro task runner. can be used for simplifing your aliases, as a

## related projects

quicksilver
navi
cmdkit

### Usage

```bash
shaml [yaml_file] [yaml_path] --param1 "value1" --param2 "value2" ...
```

### Requirements

- The YAML file must contain key-value pairs where each key represents a command and the value is the shell command to execute.
- Commands can be namespaced, allowing for hierarchical organization.
- Commands may depend on other commands defined within the same or higher-level YAML node context.
- Use Ruby's `tsort` library to resolve command dependencies before execution.

### Examples

1. **Basic Command Execution**

   - **YAML File (`actions.yaml`)**:

   ```yaml
   param: echo "None"
   hello:
     world: echo "hello, <param>"
   ```

   - **Command**:

   ```bash
   $ run-action actions.yaml hello.world
   ```

   - **Expected Output**:

   ```
   hello, None
   ```

2. **Using Parameters**

   - **YAML File (`actions.yaml`)**:

   ```yaml
   hello:
     world: echo "hello, <param>"
   ```

   - **Command**:

   ```bash
   $ run-action actions.yaml hello.world --param Me
   ```

   - **Expected Output**:

   ```
   hello, Me
   ```

3. **Command Dependency**

   - **YAML File (`actions.yaml`)**:

   ```yaml
   hello:
     param: echo "World"
     world: echo "hello, <param>"
   ```

   - **Command**:

   ```bash
   $ run-action actions.yaml hello.world
   ```

   - **Expected Output**:

   ```
   hello, World
   ```

4. **Complex Commands with Dependencies**
   - **YAML File (`actions.yaml`)**:
   ```yaml
   music:
     pick-album: find "<path>" -iname "*.m3u" | fzf
     play-album: xdg-open <pick-album>
     path: echo "$HOME/Music"
   ```
   - **Command**:
   ```bash
   $ run-action actions.yaml music.play-album
   ```
   - **Expected Behavior**:
   - The command should display a fzf interface with a list of albums and open the selected album with the default media player after selection.

### Error Handling Guidance

- Ensure that the YAML file is correctly formatted and accessible.
- Validate that all required parameters are provided; if not, display an error message indicating the missing parameters.
- Handle cases where commands depend on non-existent commands gracefully, providing informative error messages.

### Validation Criteria

- The task runner should successfully execute commands as defined in the YAML file, respecting parameter values and command dependencies.
- Output should match the expected results as demonstrated in the examples.
