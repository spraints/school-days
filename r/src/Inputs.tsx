import React from 'react';
import {ActionsProps} from './Types';

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

type Props = ActionsProps & {
  completedDays: number
  requiredDays: number
}

function Inputs(props: Props) {
  return (
    <div>
      <div className="row">
        <div className="col-2">Days completed</div>
        <div className="col-2"><input type="number" value={props.completedDays} onChange={e => props.actions.setCompletedDays(parseInt(e.target.value))} /></div>
      </div>
      <div className="row">
        <div className="col-2">Days required</div>
        <div className="col-2"><input type="number" value={props.requiredDays} onChange={e => props.actions.setRequiredDays(parseInt(e.target.value))} /></div>
      </div>
    </div>
  )
}

export default Inputs;
