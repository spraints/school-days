/* State declaration */
type state = {
  finished: int,
  required: int,
  skips: string, /* todo: was "Set ComparableDate" */
  today: string, /* todo: was "Date" */
};

/* Action declaration */
type action =
  | SetFinished(int)
  | SetRequired(int)
  | Skip(string) /* todo actually skip a date */
  | Unskip(string); /* todo also a date */

/* Component template declaration.
   Needs to be **after** state and action declarations! */
let component = ReasonReact.reducerComponent("Calendar");

let make = (_children) => {
  ...component,

  initialState: () => {finished: 0, required: 180, skips: "todo", today: "todo"},

  reducer: (action: action, state) => { ReasonReact.NoUpdate() }
/*
  reducer: (action, state) =>
    switch (action) {
      | SetFinished(finished) => ReasonReact.Update({...state, finished})
      | SetRequired(required) => ReasonReact.Update({...state, required})
      | Skip(todo) => ReasonReact.Update({...state, skips: todo})
      | Unskip(todo) => ReasonReact.Update({...state, skips: todo})
    },
    */

  render: self => {
    <div>
      <pre>(self.state)</pre>
      <div>(ReasonReact.string("todo config area"))</div>
      <div>(ReasonReact.string("todo calendar"))</div>
    </div>
  },
};
