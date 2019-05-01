
TG_ICONS=~/.local/share/TelegramDesktop/tdata/ticons
H_SIZE=22

TG_ICON_SRC=tg-counter_nobg.svg
TG_MUTED_ICON_SRC=tg-muted-counter_nobg.svg

COUNTERS := $(shell seq 1000 1 1099)

.PHONY: all

all: generate svgtopng rmsvg

# перекрас существующих иконок
grayscale:
	cd $(TG_ICONS) && \
	for i in *.png; do \
		convert "$$i" -fuzz 15% -fill 'rgb(161,161,161)' -opaque 'rgb(44,165,224)' "$$i"; \
	done

clean:
	rm -f ./temp/*

prepare:
	mkdir -p temp

# генерация набора svg иконок со счетчиком
generate:
	for n in $(COUNTERS); do \
		echo $$n  ;\
		cat $(TG_ICON_SRC) | sed "s/>0000</>$$n</" > ./temp/icon_22_$$n.svg ;\
		cat $(TG_MUTED_ICON_SRC) | sed "s/>0000</>$$n</" > ./temp/iconmute_22_$$n.svg ;\
	done

svgtopng:
	for SVG in ./temp/*.svg; do \
		inkscape -z $$SVG -w $(H_SIZE) -h $(H_SIZE) -e `echo $$SVG | sed 's/\(.*\.\)svg/\1png/'` ;\
	done

resizepng:
	for PNG in ./temp/*.png; do \
		convert  $$PNG -resize $(H_SIZE)x$(H_SIZE) $$PNG ;\
	done

rmsvg:
	rm -f ./temp/*.svg

install:
	/bin/cp -rf ./temp/*.png $(TG_ICONS)/