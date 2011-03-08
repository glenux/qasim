
UIFILES=$(wildcard *.ui)
RB_UIFILES=$(patsubst %.ui,%_ui.rb,$(UIFILES))

all: $(RB_UIFILES)

%_ui.rb: %.ui
	rbuic4 $< -o $@

clean:
	rm -f $(RB_UIFILES)
