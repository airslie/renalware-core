### Using hivemind and a Procfile

You can use [hivemind](https://github.com/DarthSim/hivemind) or
similar (overmind, foreman) to run all services together.
This is increasingly useful as we introduce rollup (for engine asset compilation) and
anycable for websockets.

### Installing on Linux.

Download the latest linux AMD 64 bit binary.
Unzip and mv into /usr/local/bin and make executable

`sudo chmod +x /usr/local/bin/hivemind`

## Running

`hivemind Profile.dev'

If you like you add an alias to .bashrc/.zshrc eg `alias hp="hivemind Procfile.dev"`
