import React, { Component } from "react";
import Circle from "./Circle";
import { Row, Container, Button, Col } from "react-bootstrap";

export default class SupportLink extends React.Component {
  render() {
    return (
      <Container fluid className="mt-5">
        <Row>
          <Col sm={2}>
            <Circle text={this.props.number} radius={40}></Circle>
          </Col>
          <Col sm={7}>
            <Container>
              <Row>
                  <h3>{this.props.title}</h3>
              </Row>
              <Row>
                
                <p>{this.props.details}</p>
              </Row>
            </Container>
          </Col>
          <Col sm={3}>
            <Button block variant="secondary">{this.props.buttonName}</Button>
          </Col>
        </Row>
      </Container>
    );
  }
}
