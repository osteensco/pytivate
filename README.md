<h2>Easier python virtual environment activation</h2>

<p>
  I honestly just hated typing out the path to the activation script. Also, what if I needed to move between different virtual environments in the same monorepo? This simple tool tries to give you less to type and make things easier without being too much. Great if you never moved on from venv.
</p>
<h3>Install</h3>
<p>
  
Uses `fzf` as a dependency. Install with your favorit package manager. 

<br>

Run the following command to install pytivate: 

```bash
curl https://raw.githubusercontent.com/osteensco/pytivate/main/src/pytivate.sh -o ~/.local/bin/pytivate && chmod +x ~/.local/bin/pytivate
```
</p>

<p>
Activate a virtual environment in your project by running

```bash 
. pytivate
```
or 
```bash
source pytivate
```

Alternatively, you can add a simple function to your .bashrc or .zshrc:

```bash
pytivate() {
  . ~/.local/bin/pytivate
}
```
And in your project just run
```
pytivate
```
</p>
