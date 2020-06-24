# (C) 2020 Marek Gagolewski, https://www.gagolewski.com

FILES_RMD = \
	000-preface.Rmd                     \
	010-introduction.Rmd                \
	020-hclust.Rmd                      \
	030-knn.Rmd                         \
	035-feature-engineering.Rmd         \
	040-trees.Rmd                       \
	050-regression-simple.Rmd           \
	060-regression-multiple.Rmd         \
	070-logistic.Rmd                    \
	080-optimisation-continuous.Rmd     \
	090-kmeans.Rmd                      \
	100-optimisation-discrete.Rmd       \
	110-feature-selection.Rmd           \
	210-images.Rmd                      \
	220-recommenders.Rmd                \
	230-text.Rmd                        \
	900-convention.Rmd                  \
	910-R-setup.Rmd                     \
	920-R-vectors.Rmd                   \
	930-R-matrices.Rmd                  \
	940-R-data-frames.Rmd               \
	950-datasets.Rmd                    \
	990-references.Rmd



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
