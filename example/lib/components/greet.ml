module Model = struct
  type t = int [@@deriving sexp_of]

  let cutoff : t -> t -> bool = ( = )

  let empty = 0
end

module State = struct
  type t = unit [@@deriving sexp_of]
end

module Action = struct
  type t =
    | Increment
    | Decrement
  [@@deriving sexp_of]

  let apply model action _state ~schedule_action:_ =
    match action with Increment -> model + 1 | Decrement -> model - 1
end

let on_startup ~schedule_action:_ _ : State.t Async_kernel.Deferred.t =
  Async_kernel.return ()

let view model ~inject =
  let open Incr_dom.Tyxml.Html in
  div
    ~a:[ a_class ["greet__container" ] ]
    [ p
        ~a:[ a_class ["greet__welcome-message"
         ] ]
        [ txt "👋 Welcome Visitor! You can edit me in"
        ; code
            [ txt
                {|
  lib/components/greet.ml|}
            ]
        ]
    ; p
        ~a:[ a_class ["greet__text"  
         ] ]
        [ txt
            "Here a simple counter example that you can look at to get started:"
        ]
    ; div
        ~a:[ a_class ["greet__button-container"  
         ] ]
        [ button
            ~a:
              [ a_button_type `Button
              ; a_onclick (fun _event -> inject Action.Decrement)
              ; a_class
                  ["greet__button"    
                  ]
              ]
            [ txt "-" ]
        ; span
            ~a:
              [ a_class
                ["greet__button"    
                ]
              ]
            [ txt (Int.to_string model) ]
        ; button
            ~a:
              [ a_button_type `Button
              ; a_onclick (fun _event -> inject Action.Increment)
              ; a_class
                ["greet__button"    
                ]
              ]
            [ txt "+" ]
        ]
    ; div
        [ span
            ~a:[ a_class ["greet__text"
              ] ]
            [ txt "And here's a link to demonstrate navigation: "
            ; Router.link ~route:Route.Home [ txt "Home" ]
            ]
        ]
    ]

let create model ~old_model:_ ~inject =
  let open Incr_dom in
  let%map.Incr model = model in
  let view = view model ~inject in
  Component.create
    model
    (Tyxml.Html.toelt view)
    ~apply_action:(Action.apply model)