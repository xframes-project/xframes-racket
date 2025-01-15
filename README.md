# xframes-racket

## Instructions

### Install Racket

#### Ubuntu

I tried using the snap package but there was a mismatch with the libc version so I ended up building racket from scratch, which was straightforward (`./configure`, `make`, `sudo make install`). This applies to my Raspberry Pi 5 too.

#### Windows

I recommend using winget:

`winget install racket.racket`

### Install dependencies

- `raco pkg install json`

### Running the application

`racket main.rkt`

## Screenshots

Windows 11

![image](https://github.com/user-attachments/assets/164f1565-4f1d-4095-8c34-8caa5bc27d51)

Ubuntu 24.04

![Screenshot from 2025-01-14 23-41-06](https://github.com/user-attachments/assets/8ea2c431-d3d9-4855-bfd5-4a516f13ac9e)

Raspberry Pi 5

![image](https://github.com/user-attachments/assets/52370e42-0a3e-4385-a26a-11a9a867e031)
