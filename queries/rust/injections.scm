; Inject into vulkano_shaders::shader!() as GLSL
(macro_invocation
  (scoped_identifier
    path: (identifier) @_path (#eq? @_path "vulkano_shaders")
    name: (identifier) @_name (#eq? @_name "shader"))

  (token_tree
    (raw_string_literal) @glsl)
)
