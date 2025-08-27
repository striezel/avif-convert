# avif-convert

Converts AVIF images to JPEG images, using a Docker container as the environment
that performs the conversion.

It's assumed that you have Docker installed, so no further information is
provided. If you need more information, take a look at
<https://docs.docker.com/>, in particular the "Get started with Docker" guide.

## Prerequisites

* Docker
* GNU Bash (or a compatible shell)
* write access to the current working directory

## Usage

To convert an AVIF image, you have to invoke the script `avif-convert.sh` from
this repository. For example, to convert the hypothetical image
`/home/user/my_image.avif` to a JPEG image, you would have to run

```sh
avif-convert.sh /home/user/my_image.avif
```

The converted image will be placed in the same directory as the original image,
but it will have the extension `.jpg` appended to its name. To stay with the
hypothetical example path from above, the converted image would be saved as
`/home/user/my_image.avif.jpg`.

## Copyright and Licensing

Copyright 2023, 2025  Dirk Stolle

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
