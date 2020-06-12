# (C) 2020 Marek Gagolewski, https://www.gagolewski.com

FILES_RMD = \
	00-preface.Rmd                     \
	01-introduction.Rmd                \
	02-hclust.Rmd                      \
	03-knn.Rmd                         \
	04-trees.Rmd                       \
	05-regression-simple.Rmd           \
	06-regression-multiple.Rmd         \
	07-logistic.Rmd                    \
	08-optimisation-continuous.Rmd     \
	09-kmeans.Rmd                      \
	10-optimisation-discrete.Rmd       \
	11-images.Rmd                      \
	12-recommenders.Rmd                \
	13-text.Rmd                        \
	90-convention.Rmd                  \
	91-R-setup.Rmd                     \
	92-R-vectors.Rmd                   \
	93-R-matrices.Rmd                  \
	94-R-data-frames.Rmd               \
	95-datasets.Rmd                    \
	99-references.Rmd



FILES_SVGZ = \
	figures/convex_concave.svgz                   \
	figures/convex_function.svgz                  \
	figures/convex_set.svgz                       \
	figures/logistic_regression_binary.svgz       \
	figures/logistic_regression_multiclass.svgz   \
	figures/neuron.svgz                           \
	figures/nnet.svgz                             \
	figures/perceptron.svgz


VPATH=.


.PHONY: all docs md latex gitbook figures clean purge

all: docs


docs: latex gitbook
	rm -f -r docs
	mkdir docs
	cp -f -r out-gitbook/* docs/
	cp -f -r out-latex/* docs/
	cp -f build/CNAME.tpl docs/CNAME


clean:
	rm -f -r tmp-gitbook tmp-latex  \
	         out-gitbook out-latex
purge:
	rm -f -r tmp-gitbook tmp-latex tmp-md \
	         out-gitbook out-latex



PDF_OUTPUTS=$(patsubst %.svgz,%.pdf,$(FILES_SVGZ))
SVG_OUTPUTS=$(patsubst %.svgz,%.svg,$(FILES_SVGZ))


figures: $(PDF_OUTPUTS) $(SVG_OUTPUTS)

figures/%.svg: figures/%.svgz
	inkscape -C "$<" --export-type=svg --export-plain-svg  --export-area-page -o "$@"

figures/%.pdf: figures/%.svgz
	inkscape  -C  "$<" --export-type=pdf   --export-area-page -o "$@"



TMP_MD=$(patsubst %.Rmd,tmp-md/%.md,$(FILES_RMD))
TMP_LATEX=$(patsubst tmp-md/%.md,tmp-latex/%.Rmd,$(TMP_MD))
TMP_GITBOOK=$(patsubst tmp-md/%.md,tmp-gitbook/%.Rmd,$(TMP_MD))

md: figures $(TMP_MD)
	build/render_md.sh

latex: $(TMP_LATEX)
	build/render_latex.sh

latex-draft: $(TMP_LATEX)
	LATEX_DRAFT=1 build/render_latex.sh

gitbook: $(TMP_GITBOOK)
	build/render_gitbook.sh

tmp-md/%.md: %.Rmd
	build/Rmd2md.sh "$<"

tmp-latex/%.Rmd: tmp-md/%.md
	build/md2md_latex.sh "$<"

tmp-gitbook/%.Rmd: tmp-md/%.md
	build/md2md_gitbook.sh "$<"
