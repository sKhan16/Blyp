import React from "react";
import Jumbotron from "react-bootstrap/Jumbotron";
import SupportLink from "./SupportLink";
import { Col, Container, Row } from "react-bootstrap";

export default class Support extends React.Component {
  render() {
    return (
      <div className="support text-left pt-0 pb-0">
        <h2 className="header display-4 font-weight-bold">how can you support?</h2>
        <Row>
          <Col>
            <SupportLink
              title={"take our survey"}
              details="An anonymous Google form about your general experiences regarding passing and loss. The survey takes about 5-10 minutes."
              buttonName="General survey"
              buttonHref="https://forms.gle/syDWc5oLZiQ3mnwa9"
            ></SupportLink>
          </Col>

          <Col>
            <SupportLink
              title={"interview with us"}
              details="If you have worked with those at end of life, are preparing for end of life, or are preparing to lose a loved one, we would love to interview you!"
              buttonName="Interview sign up"
              buttonHref="https://forms.gle/Kw2JkxV8DnjjL1q46"
            ></SupportLink>
          </Col>
        </Row>
      </div>
    );
  }
}
