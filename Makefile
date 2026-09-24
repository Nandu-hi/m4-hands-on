JUNIT_URL := https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.10.0/junit-platform-console-standalone-1.10.0.jar
JUNIT_JAR := libs/junit.jar

SRCS := $(shell find src -name '*.java' 2>/dev/null)
TESTS := $(shell find test -name '*.java' 2>/dev/null)

.PHONY: deps build test pmd spotbugs clean

deps: $(JUNIT_JAR)

$(JUNIT_JAR):
	@mkdir -p libs
	@curl -sSL -o $@ $(JUNIT_URL)

build: deps
	@mkdir -p build
	javac --release 17 -d build -cp $(JUNIT_JAR) $(SRCS) $(TESTS)

test: build
	java -jar $(JUNIT_JAR) --class-path build --scan-class-path

pmd:
	-pmd check -d src -R rulesets/java/quickstart.xml -R category/java/design.xml/CyclomaticComplexity -f text

spotbugs: build
	spotbugs -textui -auxclasspath $(JUNIT_JAR) build

clean:
	rm -rf build libs
