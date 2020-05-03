import React from "react";
import Jumbotron from "react-bootstrap/Jumbotron";

export default class Purpose extends React.Component {
  render() {
    return (
      <div className="text-left pb-0">
        <h1 className="header display-3 font-weight-bold headline">a new way for mapping memories</h1>
        <p>
          Hello, we’re a team of four students building a mobile application that allows people to leave memories
          (blyps) on a map. Friends and family alike can then go and “look for” these memories--think geocaching, but
          looking for digital artifacts. A letter, a memory, a photo. Anything you can imagine.
        </p>
        <p className="font-weight-bold">
          We are hoping to build a social media platform catered towards the end of life community, for four main
          reasons:
        </p>
        <ol>
          <li>To make the act of “leaving behind something of importance” more accessible.</li>
          <li>
            To fill a need; there are no existing social media platforms designed with the end of life community in
            mind.
          </li>
          <li>To give people more control over their legacy after they die.</li>
          <li>
            To create conversation around and to normalize the topic of death, and to help society have healthier
            relationships with loss.
          </li>
        </ol>
      </div>
    );
  }
}
