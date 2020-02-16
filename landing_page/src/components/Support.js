import React from "react";
import Jumbotron from "react-bootstrap/Jumbotron";
import SupportLink from "./SupportLink";

export default class Support extends React.Component {
  render() {
    return (
      <Jumbotron className="bg-white text-left pt-0">
        <h2 className="display-4 font-weight-bold">How you can support</h2>
        <SupportLink
          number={1}
          title={"TAKE OUR SURVEY"}
          details="A Google form; takes 5-10 minutes!"
          buttonName="GENERAL SURVEY"
          buttonHref=""
        ></SupportLink>
        <SupportLink
          number={2}
          title={"INTERVIEW WITH US"}
          details="If you have worked with those at end of life, are preparing for end of life, or are preparing to lose a loved one, we would love to interview you. Cup of coffee on us!"
          buttonName="SIGN UP TO INTERVIEW"
          buttonHref=""
        ></SupportLink>
      </Jumbotron>
    );
  }
}
