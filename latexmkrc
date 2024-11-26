$pdf_mode = 1;
$postcript_mode = 0;
$dvi_mode = 0;
$clean_ext = 'synctex.gz synctex.gz(busy) acn acr alg aux bbl bcf blg brf fdb_latexmk glg glo gls idx ilg ind ist lof log lot out run.xml toc dvi';
$pdflatex = "pdflatex -synctex=1 -interaction=nonstopmode";
@generated_exts = (@generated_exts, 'synctex.gz');
$aux_dir = 'build';
