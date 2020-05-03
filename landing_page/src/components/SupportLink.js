import React, { Component } from "react";
import Circle from "./Circle";
import { Row, Container, Button, Col } from "react-bootstrap";

export default class SupportLink extends React.Component {
  render() {
    return (
      <Container fluid className="mt-5">
        <Row>
            <Container>
              <Row>
                <h3>{this.props.title}</h3>
              </Row>
              <Row>
                <p>{this.props.details}</p>
              </Row>
            </Container>
          
            <div className="blyp-button">
              <a href={this.props.buttonHref}>{this.props.buttonName}</a>
            </div>
        </Row>
      </Container>
    );
  }
}
