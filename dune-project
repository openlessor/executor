(lang dune 3.20)

(name executor)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name <author@example.com>")

(maintainers "Maintainer Name <maintainer@example.com>")

(license LICENSE)

(documentation https://url/to/documentation)

(using melange 0.1)

(package
 (name executor)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends
  ocaml
  (melange
   (>= "6.0.0"))
  ocaml-lsp-server
  ocamlformat
  reason
  melange-webapi
  (ppxlib
   (= 0.33))
  reason-react-ppx
  (reason-react
   (>= 0.16.0)))
 (allow_empty)
 (tags
  ("add topics" "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
