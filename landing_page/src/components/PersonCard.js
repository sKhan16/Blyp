import React from "react";
import { Col, Container, Row } from "react-bootstrap";

export default class PersonCard extends React.Component {
  render() {
    const picSize = 150;
    return (
      <Col className="text-center">
        <Container>
          <Row>
            <Col>
              <img
                src={this.props.imgSrc}
                height={picSize}
                width={picSize}
                style={{ borderRadius: "50%" }}
              />
            </Col>
          </Row>
          <Row>
            <Col>
              <h4 width="100%">{this.props.name}</h4>
            </Col>
          </Row>
          <Row>
            <Col>
              <p width="100%">{this.props.role}</p>
            </Col>
          </Row>
          <Row>
            <Col>
              <p width="100%">{this.props.email}</p>
            </Col>
          </Row>
          <Row>
            <Col>
              <p width="100%">{this.props.quip}</p>
            </Col>
          </Row>
        </Container>
      </Col>
    );
  }
}
