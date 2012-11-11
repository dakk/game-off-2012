COFFEE=coffee

all: 
	$(COFFEE) --compile --output js coffee

clean:
	-rm $(SOURCES)
  
