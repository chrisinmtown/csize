# 
# $RCSfile: Makefile,v $
#
# makefile that kicks off regression test for csize
# and evaluates the results.  Input files are referenced
# directly from the two testing scripts; they are not
# passed as parameters.
#

OUTPUTTEST	= ./TEST-OUT.sh
OUTPUTEXPECTED	= ./TEST-OUT.ok
OUTPUTOUT	= ./TEST-OUT.out

COUNTTEST	= ./TEST-COUNT.sh
COUNTEXPECTED	= ./TEST-COUNT.ok
COUNTOUT	= ./TEST-COUNT.out

DIFF = diff
# DIFFOPTS = -c	     # context diffs are very wordy
DIFFOPTS = 

ALLFILES=Makefile README CMP-COUNTS.sh \
	$(OUTPUTTEST) $(OUTPUTEXPECTED) \
	$(COUNTTEST)  $(COUNTEXPECTED)

all:	../csize version output counts

version:
	@echo ""
	@echo "Regression suite for csize, R$Revision: 1.17 $ "
	@echo ""

output: $(OUTPUTTEST) $(OUTPUTEXPECTED)
	@echo ""
	@echo "Running regression test for output (silently)."
	@echo "Please wait a moment."
	$(OUTPUTTEST) > $(OUTPUTOUT) 2>&1
	@echo ""
	@echo "Differences from expected:"
	@echo "-- Although no news is good news, you may see a difference"
	@echo "-- with text 'csize: illegal option -- u'; this is caused"
	@echo "-- by a different implementation of getopt() and is OK."
	-$(DIFF) $(DIFFOPTS) $(OUTPUTOUT) $(OUTPUTEXPECTED)

counts: $(COUNTTEST) $(COUNTEXPECTED)
	@echo ""
	@echo "Running regression test for counts (silently)."
	@echo "Please wait a little longer, maybe a few minutes."
	$(COUNTTEST) > $(COUNTOUT) 2>&1
	@echo ""
	@echo "Differences from expected: (no news is good news)"
	-$(DIFF) $(DIFFOPTS) $(COUNTOUT) $(COUNTEXPECTED)

checkout:
	co -l $(ALLFILES) *.c

checkin:
	ci -f -u $(ALLFILES) *.c

patch:
	-rcsdiff -q -c -r1.12 $(ALLFILES) *.c > $@

clean:
	rm -f $(OUTPUTOUT) $(COUNTOUT)
