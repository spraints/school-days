import React from 'react';

export function SkipButton() {
  return <div>(skip)</div>
}

export function UnskipButton() {
  return <div>(unskip)</div>
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
