.PHONY: run-src symbolics clean dist run-dist

love = "love"
open = "open"

rootd = `pwd`
srcd = "$(rootd)/src"
gamename = 7min.love

run-src:# symbolics
	$(love) $(srcd)

symbolics:
	@cd src && ln -s ../assets/images images && cd ..
	@cd src && ln -s ../assets/sounds sounds && cd ..

clean:
	@rm -rf dist src/images src/sounds

dist:
	@mkdir -p dist
	@cd src && zip -9 -q -r ../dist/$(gamename) . && cd ..
	@cd assets && zip -9 -q -r ../dist/$(gamename) . && cd ..

run-dist: dist
	$(open) dist/$(gamename)
