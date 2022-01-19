# Used by "mix format"
[
  inputs: ["mix.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: [
    let: 1
  ],
  export: [
    let: 1
  ],
  import_deps: [
    :operator,
    :doma_quark,
    :type_class
  ]
]
