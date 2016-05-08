.PHONY: run-src moon symbolics clean dist run-dist

love = /Applications/love.app/Contents/MacOS/love
rootd = `pwd`
srcd = "$(rootd)/src"
gamename = 7min.love

run-src: moon
	$(love) $(srcd)

moon:
	moonc src/*.moon

symbolics:
	@cd src && ln -s ../assets/images images && cd ..
	@cd src && ln -s ../assets/sounds sounds && cd ..

clean:
	@rm -rf dist src/images src/sounds

dist: moon
	@mkdir -p dist
	@cd src && zip -9 -q -r ../dist/$(gamename) . && cd ..
	@cd assets && zip -9 -q -r ../dist/$(gamename) . && cd ..

run-dist: dist
	open dist/$(gamename)
