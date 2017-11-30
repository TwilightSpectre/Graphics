CC  := clang
CXX := clang++

LIBDIR := lib
SRCDIR := src

LIBS  := $(LIBDIR)/src/jsoncpp.o $(LIBDIR)/src/glad.o
BIN   := graphics

DEBUGDIR := debug
DEBUGBIN := graphics_d

OBJDIR := .o
DEPDIR := .d

CXXFLAGS := -c -stdlib=libc++ -std=c++1z -W{all,extra,error,no-unused-parameter} -pedantic -isystem ./$(LIBDIR)/include
CFLAGS   := -c -isystem ./$(LIBDIR)/include
LDFLAGS  := -stdlib=libc++ -lglfw -ldl

DEBUG ?= 1
ifeq ($(DEBUG), 1)
	CXXFLAGS += -DDEBUG -g -fno-limit-debug-info
	LDFLAGS += -g -fno-limit-debug-info
	OBJDIR := $(DEBUGDIR)/$(OBJDIR)
	DEPDIR := $(DEBUGDIR)/$(DEPDIR)
	BIN := $(DEBUGBIN)
endif

DEPFLAGS    = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.Td
POSTCOMPILE = @mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d && touch $@

SRCS := $(wildcard src/*.cpp)
OBJS := $(patsubst $(SRCDIR)/%.cpp,$(OBJDIR)/%.o,$(SRCS))

$(shell mkdir -p $(OBJDIR) $(DEPDIR) >/dev/null)

.PHONY : all
all : $(BIN)

$(BIN) : $(OBJS) $(LIBS)
	$(CXX) $(LDFLAGS) $^ -o $@

$(LIBDIR)/src/glad.o : $(LIBDIR)/src/glad.c
	$(CC) $(CFLAGS) $< -o $@

$(LIBDIR)/src/%.o : $(LIBDIR)/src/%.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

$(OBJDIR)/%.o : $(SRCDIR)/%.cpp $(DEPDIR)/%.d
	$(CXX) $(CXXFLAGS) $(DEPFLAGS) $< -o $@
	$(POSTCOMPILE)

$(DEPDIR)/%.d : ;
.PRECIOUS : $(DEPDIR)/%.d

.PHONY : clean fullclean
clean :
	rm -f $(BIN) $(DEBUGBIN)
	rm -rf $(DEPDIR) $(OBJDIR) $(DEBUGDIR)

fullclean : clean
	find . -name '*.o' -delete

include $(wildcard $(patsubst %, $(DEPDIR)/%.d, $(basename $(SRCS))))
