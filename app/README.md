Make sure FVM is installed
```bash
brew install fvm
```
Make sure the correct flutter sdk is installed with fvm
```bash
fvm install
```
Bootstrap all packages with Melos
```bash
fvm dart run melos bs
```

Run code generation for all packages
```bash
fvm dart run melos run build_runner 
```

PS: Always run these commands from the workspace root. 