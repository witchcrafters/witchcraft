%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "test"],
        excluded: []
      },
      checks: [
        {Credo.Check.Consistency.TabsOrSpaces},
        {Credo.Check.Design.AliasUsage, false},
        {Credo.Check.Readability.MaxLineLength, priority: :low, max_length: 100},
        {Credo.Check.Readability.PipeIntoAnonymousFunctions, false},
        # This rule incorrectly flags uses of Witchcraft.Semigroupoid.apply/2
        {Credo.Check.Refactor.Apply, false}
      ]
    }
  ]
}
