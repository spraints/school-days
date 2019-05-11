import React from 'react';
import {WeekData, DayData, DayOfWeek} from './Types';
import {SkipButton, UnskipButton} from './Inputs';

type Props = {
  days: WeekData
}

function Week(props: Props) {
  return (
    <div className="row week">
      <div className="col controls">
        <SkipButton/>
        <UnskipButton/>
      </div>
      {props.days.map(renderDay)}
    </div>
  )
}

function renderDay(day: null | DayData) {
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
        <UnskipButton />
      </div>
    );
  } else {
    return (
      <div className="col day school">
        <div className="dayNum">{day.day}</div>
        <div className="content">SCHOOL</div>
        <SkipButton />
      </div>
    );
  }
}

export default Week
