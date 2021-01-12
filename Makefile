# Modify these next four lines if you want to use a different C++,
# Java, or Python implementation
CXX=g++
JAVAC=javac
JAVA=java
PYTHON=python3

TEST=test.jpl

all: run

compiler.pyc: compiler.py
	$(PYTHON) -m py_compile $^

compiler.o: compiler.cpp
	$(CXX) -c -o $@ $^

compiler.class: compiler.java
	$(JAVAC) $^

source_files: $(wildcard ./compiler.cpp)$(wildcard ./compiler.java)$(wildcard ./compiler.py)

compile:
ifeq (./compiler.cpp,$(source_files))
	@$(MAKE) compile-cpp
else ifeq (./compiler.java,$(source_files))
	@$(MAKE) compile-java
else ifeq (./compiler.py,$(source_files))
	@$(MAKE) compile-py
else ifeq (,$(source_files))
	$(error Cannot find C++, Java, or Python source code)
else
	$(error Please select exactly one of C++, Java, or Python source code)
endif

compile-cpp: compiler.o

compile-java: compiler.class

compile-py: compiler.pyc

run:
ifeq (./compiler.cpp,$(source_files))
	@$(MAKE) run-cpp
else ifeq (./compiler.java,$(source_files))
	@$(MAKE) run-java
else ifeq (./compiler.py,$(source_files))
	@$(MAKE) run-py
else ifeq (,$(source_files))
	$(error Cannot find C++, Java, or Python source code)
else
	$(error Please select exactly one of C++, Java, or Python source code)
endif

run-cpp: compiler.o
	$(CXX) compiler.o -o a.out
	./a.out $(TEST)

run-java: compiler.class
	$(JAVA) compiler $(TEST)

run-py:
	$(PYTHON) compiler.py $(TEST)
