```bash
   ___
  (_- \   
 / ___/_  
/  ___  \
\_ _ _ _/    p y t i v a t e
```
<h2>Easier python virtual environment activation</h2>

<p>
  I honestly just hated typing out the path to the activation script. Also, what if I needed to move between different virtual environments in the same monorepo? Also also, if I move my virtual environment to another folder it breaks which is annoying. It would be nice if the virtual environment scripts just fixed themselves. This simple tool tries to give you less to type and make things easier without trying to do too much. If you're using a more modern python virtual environment manager, this isn't for you, but if you never moved on from venv this tool is great.
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

Activate a virtual environment in your project by sourcing pytivate. This will bring up fzf with a list of available virtual environments pytivate found. If you move your virtual environment to another folder, you will notice pytivate fixing broken paths for you next time you use it.

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
