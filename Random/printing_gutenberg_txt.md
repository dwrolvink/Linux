# Printing textfiles from the Gutenberg project
In this tutorial, I'll show you how you can convert a plain text document to a pdf ready for printing in book format.
This book will have multiple _signatures_, which is a fancy way of saying that we print many thin booklets, and stack
them together to build the final book. Thin books (max 32 pages) can be printed as a single booklet.

We'll be using [this book](https://www.gutenberg.org/files/1717/1717-0.txt), and (Manjaro) linux for this example. (Any 
linux distro will do).

For those who are short on time/attentionspan, this is the summary of what we'll do here (minus adjusting the fontsize!):
```bash
# Create pdf from .txt
pandoc -V geometry:margin=1in -o output.pdf input.txt 

# Adjust margins for printing
pdfjam output.pdf --offset '0.3in 0in' --twoside --suffix 'margins'

# Create booklet (with 5 signatures, each containing 32 pages)
pdfjam --landscape --signature 32 output-margins.pdf -o booklet.pdf
```

### Installing the requirements
First, install the packages, these are pandoc and texlive-core. Texlive-core contains pdfjam, which we'll use to create
the booklets. (Note that this is the name of the Arch package, on Debian based systems pdfjam is in texlive-extra).
Pandoc contains... pandoc. This program we'll use to convert the .txt to a simple pdf. Make sure you don't opt-out of the LateX dependencies when installing pandoc, they are vital. 

### Convert .txt to pdf
I found out with the first test print that the standard fontsize is way too small to read. So firstly, we'll add the following 
to the beginning of the textfile:

```bash
---
documentclass: extarticle
fontsize: 14pt
---
```

Pandoc will take this in as variables, and cut out this block before turning the text file into a pdf. Note that some distributions of pandoc don't automatically install the extarticle package. Do some websearching on what to install on your distro if this is the case for you.

Next, we'll create the pdf:

```bash
pandoc -V geometry:margin=1in -o output.pdf input.txt 
```

I changed the margin, because I don't like large margins. (At this point of the process though, I see the value of larger margins.)
Make some test prints, and look at what margin works for you.

### Creating the booklet
Talking about margins, we'll want some extra margin on the inside of our book, because the book folds there, and this can
make it hard to read the entire page. When we print two pages on one print face, this
means that the two pages are not centered on their respective half faces, but are positioned a bit more to the outer edges.
To do this, we include the `--offset` variable. This will add margin on the left side by 0.3 inches. To do this alternatingly 
between left/right offset, we add the `--twoside` variable. This way, all odd numbered pages (which land on the right side), will
be offset slightly to the right, and vice versa for the even numbered pages.

```bash
pdfjam output.pdf --offset '0.3in 0in' --twoside --suffix 'margins'
```

The line above will create the file "output-margins.pdf". This is still a single page/print face pdf. We want to print it in 
such a way that we can fold over the printed stack of paper (or signature) and have a booklet. This involves printing in duplex (twosided), and 
shuffling the pages around a little. Most adobe pdf readers have this option built in, but I can't (/won't) use those here.

If you can print everything in one booklet, use the first line, otherwise, use the second. The second splits up the book into `n` 
signatures. Signatures are separate booklets that you can fold separately, and then stack on top of eachother to create the book.
This is how most books are bound since the creation of books. It helps with the folding open of the booklet, and with the curvature
that occurs at the extremities, because the pages that go along the back of the booklet have to cross a longer route than those 
in the center. Even with signatures, you'll still have this effect. I found that with signatures with more than 4 pages, this 
effect is already noticeable (though subtle). That's why books are often cut after binding. This is hard to do at home without 
[a hefty page cutter though](http://www.dwrolvink.com/md/img/papercutter.jpg). 

Note that the number after `--signature` has to be
a multiple of 4, because the smallest booklet is 4 pages printed on one piece of paper (two on each side). If you have less pages 
than the smallest multiple of the signature, you will get some blank pages at the end of your book. (pages%signature=number of 
blank pages at the end).

```
# One booklet (i.e. one fold)
pdfjam output.pdf --suffix 'one book'

# For bigger books, make smaller booklets (signatures), and glue them together:
# has to be a multiple of 4
pdfjam --landscape --signature 32 output-margins.pdf -o booklet.pdf
```
### Printing & binding
Now you have your booklet! Make sure to print this booklet with duplex printing turned on, and page scaling set to "fit the page",
instead of "normal" (this introduces extra margin on the left on my printer which skews my print). I also had to select my paper
source size (A4 for me), to make sure the "fit the page" scaling was done correctly.

Quick tip also: when printing with signatures, the first page will say "n ___ 1" as page numbers. All of the pages in the signature are in between 1 and n. This means that the signature
ends when you find a page that has n+1 on the right side. Take the first signature and fold it over so the pages 1 and n are on the outside, and then continue to the next signature. You can use thread and needle to tie the signatures, and then press the 
signature stack between two pieces of wood and use woodglue and some fabric to make the spine of the book.

Good luck, and [let me know](https://github.com/dwrolvink/HelloWorld) if you have any questions!

