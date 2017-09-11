collection @footnotes

node do |footnote|
  {
  :id => footnote.id,
  :code => footnote.code || "",
  :label => footnote.label || ""
  }
end
