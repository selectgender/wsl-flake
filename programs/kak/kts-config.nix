{
  language = {
    luau = {
      grammar = {
        path = "src";
        compile = "cc";
        compile_args = [
          "-c"
          "-fpic"
          "../scanner.c"
          "../parser.c"
          "-I"
          ".."
        ];
        compile_flags = [ "-O3" ];
        link = "cc";
        link_args = [
          "-shared"
          "-fpic"
          "scanner.o"
          "parser.o"
          "-o"
          "luau.so"
        ];
        link_flags = [ "-O3" ];
        source.git = {
          url = "https://github.com/polychromatist/tree-sitter-luau";
          pin = "40bd6e9733af062d9e60b2c879e0ba4c759c675f";
        };
      };
      queries = {
        path = "helix-queries";
        source.git = {
          url = "https://github.com/polychromatist/tree-sitter-luau";
          pin = "40bd6e9733af062d9e60b2c879e0ba4c759c675f";
        };
      };
    };
  };
}
