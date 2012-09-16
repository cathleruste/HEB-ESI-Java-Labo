# ===============================================================
# Automationsation de la création des documents
# make pdf : pour créer les PDFs
# make html : pour créer les versions en-ligne 
# make scorm : pour créer les versions au format SCORM pour poÉSI
# make all : pour tout créer
# ===============================================================

# =========================================
# Notes de syntaxe pour comprendre la suite
# =========================================

# wildcard : permet d'avoir une liste où les wildcard sont utilés
# basename : enlève l'extension
# notdir   : enlève les dossiers devant
# Dans une cible : '%' est l'équivalent du '*'
# Dans les dépendances et les règles, '$@' signifie la cible
# Dans les règles, $* signifie ce qui a été choisi pour le % dans la cible

DIST    = dist/
SOURCES = $(wildcard */fr/text/*.xml)
LECONS  = $(notdir $(basename $(SOURCES)))
PDFS    = $(addsuffix .pdf, $(addprefix $(DIST), $(LECONS)))
HTMLS   = $(addsuffix .html, $(addprefix $(DIST), $(LECONS)))
SCORMS  = $(addsuffix .zip, $(addprefix $(DIST), $(LECONS)))

.PHONY: default
.PHONY: pdf
.PHONY: html
.PHONY: scorm
.PHONY: all
.PHONY: clean

default: pdf
all: pdf scorm html 

pdf: $(PDFS)
dist/%.pdf: %/fr/text/*.xml
	@./elml pdf $*

html: $(HTMLS)
dist/%.html: %/fr/text/*.xml
	@./elml html $*

scorm: $(SCORMS)
dist/%.zip: %/fr/text/*.xml
	@./elml scorm $*

debug:
	@echo "*** SOURCES : $(SOURCES)"
	@echo "*** LECONS : $(LECONS)"
	@echo "*** PDFS : $(PDFS)"

clean:
	rm -f dist/*
