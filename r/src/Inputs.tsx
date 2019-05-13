import React from 'react';

type ButtonProps = {
  children?: any
  action: () => void
}

export function Button(props: ButtonProps) {
  return (
    <div>
      <button type="button" className="btn btn-link" onClick={props.action}>{props.children}</button>
    </div>
  )
}

function Inputs() {
  return (
    <div>
      <div className="row">
        <div className="col-2">Days completed</div>
        <div className="col-2">(input box)</div>
      </div>
      <div className="row">
        <div className="col-2">Days required</div>
        <div className="col-2">(input box)</div>
      </div>
    </div>
  )
}

export default Inputs;
