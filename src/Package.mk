# Makefile to create distribution package

CP = cp -p
RM = rm
MKDIR = mkdir
ZIP = zip -9
STRIP = strip
U8TOSJ = u8tosj

SRCDIR_MK = ../srcdir.mk
SRC_DIR = ../src
-include $(SRCDIR_MK)

T = pkgtmp

GCC_ZIP = gcc130p.zip

FILES = bin/gcc.x bin/gcc_cc1.x bin/gcc_cpp.x lib/libgnu.a \
	COPYING gcc_help.txt \
	CHANGELOG.txt README.txt libgcc_CHANGELOG.txt libgcc_README.txt

.PHONY: all archive directories

all: directories $(GCC_ZIP)

directories: $(T) $(T)/bin $(T)/lib

$(T) $(T)/bin $(T)/lib:
	$(MKDIR) $@

$(GCC_ZIP): $(addprefix $(T)/,$(FILES))
	(cd $(T); $(ZIP) ../$@ $(FILES))

$(T)/bin/gcc.x: gcc.x
	$(CP) $^ $@
	$(STRIP) $@

$(T)/bin/gcc_cc1.x: gcc_cc1.x
	$(CP) $^ $@
	$(STRIP) $@

$(T)/bin/gcc_cpp.x: gcc_cpp.x
	$(CP) $^ $@
	$(STRIP) $@

$(T)/lib/libgnu.a: ../libgcc/build/libgcc.a
	$(CP) $^ $@

$(T)/COPYING: $(SRC_DIR)/../COPYING
	$(CP) $^ $@

$(T)/gcc_help.txt: $(SRC_DIR)/../gcc_help.txt
	$(U8TOSJ) < $^ >! $@

$(T)/CHANGELOG.txt: $(SRC_DIR)/../CHANGELOG.md
	$(U8TOSJ) < $^ >! $@

$(T)/README.txt: $(SRC_DIR)/../README.md
	$(U8TOSJ) < $^ >! $@

$(T)/libgcc_CHANGELOG.txt: $(SRC_DIR)/../libgcc/CHANGELOG.md
	$(U8TOSJ) < $^ >! $@

$(T)/libgcc_README.txt: $(SRC_DIR)/../libgcc/README.md
	$(U8TOSJ) < $^ >! $@

