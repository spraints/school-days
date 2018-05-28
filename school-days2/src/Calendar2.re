/* State declaration */
type state = {
  count: int,
  show: bool,
  today: string,
  finished: int,
  required: int,
  skipped: string,
};

/* Action declaration */
type action =
  | FFuu(int)
  | Click
  | Toggle;

/* Component template declaration.
   Needs to be **after** state and action declarations! */
let component = ReasonReact.reducerComponent("Example");

/* greeting and children are props. `children` isn't used, therefore ignored.
   We ignore it by prepending it with an underscore */
let make = (_children) => {
  /* spread the other default fields of component here and override a few */
  ...component,

  initialState: () => {count: 0, show: true, today: "todo", finished: 0, required: 180, skipped: "todo"},

  /* State transitions */
  reducer: (action, state) =>
    switch (action) {
    | FFuu(_) => ReasonReact.NoUpdate
    | Click => ReasonReact.Update({...state, count: state.count + 1})
    | Toggle => ReasonReact.Update({...state, show: ! state.show})
    },

  render: self => {
    let message =
      "You've clicked this " ++ string_of_int(self.state.count) ++ " times(s)";
    <div>
      <button onClick=(_event => self.send(Click))>
        (ReasonReact.string(message))
      </button>
      <button onClick=(_event => self.send(Toggle))>
        (ReasonReact.string("Toggle greeting"))
      </button>
      (self.state.show ? ReasonReact.string("yay2") : ReasonReact.null)
    </div>;
  },
};
