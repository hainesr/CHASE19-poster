# What Makes Research Software Sustainable? An Interview Study With Research Software Engineers

## Mário Rosado de Souza, Robert Haines, Markel Vigo, Caroline Jay

Scripts and data for our poster, presented at [CHASE19](http://www.chaseresearch.org/workshops/chase2019).

Preprint: https://arxiv.org/abs/1903.06039

Data: https://doi.org/10.5281/zenodo.1345066

### Requirements

To process this data you will need:

* `pdfunite`
* `pdftotext`
* `ruby` - version 2.4.1 is known to work.

### Usage

From the root directory of the repository, simply run:

```shell
$ make
```

The output will be produced in `WordCounts.txt`. It has a simple format:

```
<count> <lowercase-word>
.
.
.
```

You can copy and paste as much of this file as you like into the Word Cloud generator at https://www.wordclouds.com/ and then play with the settings to produce something aesthetically pleasing.

### Licence

All code is released under the BSD licence. See LICENCE for more details.
