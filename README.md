<h2>Easier python virtual environment activation</h2>

<p>
  I honestly just hated typing out the path to the activation script. Also, what if I needed to move between different virtual environments in the same monorepo? This simple tool tries to give you less to type and make things easier without being too much. Great if you never moved on from venv.
</p>
<h3>Install</h3>
<p>
  
Unix-like os and bash or zsh shells, maybe others. Uses `fzf` as a dependency.

<br>

Run the following command to install pytivate: 

```bash
curl https://raw.githubusercontent.com/osteensco/pytivate/main/src/pytivate.sh -o ~/.local/bin/pytivate && chmod +x ~/.local/bin/pytivate
```
</p>

<h3>Use</h3>

<p>

Activate a virtual environment in your project by sourcing pytivate. This will bring up fzf with a list of available virtual environments pytivate found.

```bash 
source pytivate
```
pytivate prompts for confirmation by default but a '-y' flag can be passed in to skip this 
```bash
. pytivate -y
```

Alternatively, you can add a simple function to your .bashrc or .zshrc:

```bash
pytivate() {
  . ~/.local/bin/pytivate -y
}
```
And in your project just run
```
pytivate
```
<br>

Pytivate just looks for subdirectories with certain names. This list can be adjusted in your .bashrc or .zshrc using the `VENV_NAMES` variable. The will supercede 
the defaults which are `DEFAULT_NAMES=("venv" ".venv" "env" ".env")`.

</p>
