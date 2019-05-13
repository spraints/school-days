import React from 'react';
import {ActionsProps, MonthDay, WeekData, DayData, DayOfWeek} from './Types';
import {Button} from './Inputs';
import {filterNonNull} from './utils';

type Props = ActionsProps & {
  month: string
  days: WeekData
}

function Week(props: Props) {
  return (
    <div className="row week">
      <div className="col controls">
        <Button action={act(props.actions.onSkip, props.month, props.days)}>
          skip
        </Button>
        <Button action={act(props.actions.onUnskip, props.month, props.days)}>
          unskip
        </Button>
      </div>
      {props.days.map(day => <Day actions={props.actions} month={props.month} day={day} />)}
    </div>
  )
}

type DayProps = ActionsProps & {
  month: string
  day: null | DayData
}

function Day(props: DayProps) {
  const {day, month, actions} = props
  if (day == null) {
    return <div className="col"></div>;
  } else if (day.dow === DayOfWeek.Sunday || day.dow === DayOfWeek.Saturday) {
    return (
      <div className="col day weekend">
        <div className="dayNum">{day.day}</div>
      </div>
    );
  } else if (day.skipped) {
    return (
      <div className="col day skipped">
        <div className="dayNum">{day.day}</div>
        <div className="content">NO SCHOOL</div>
        <Button action={act(actions.onUnskip, month, [day])}>unskip</Button>
      </div>
    );
  } else {
    return (
      <div className="col day school">
        <div className="dayNum">{day.day}</div>
        <div className="content">SCHOOL</div>
        <Button action={act(actions.onSkip, month, [day])}>skip</Button>
      </div>
    );
  }
}

function act(fn: (days: Array<MonthDay>) => void, month: string, days: Array<null | DayData>) {
  return () => fn(filterNonNull(days).map(day => ({month: month, day: day.day})))
}

export default Week
