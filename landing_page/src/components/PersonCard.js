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
                alt={"A photo of " + this.props.name}
              />
            </Col>
          </Row>
          <Row className="mt-0 mb-0">
            <Col>
              <h5 className="name" width="100%">{this.props.name}</h5>
            </Col>
          </Row>
          <Row className="mt-0 mb-0">
            <Col>
              <p className="role" width="100%">{this.props.role}</p>
            </Col>
          </Row>
          <Row className="mt-0 mb-0">
            <Col>
              <p className="email" width="100%">{this.props.email}</p>
            </Col>
          </Row>
          <Row className="mt-0 mb-0">
            <Col>
              <p className="bio" width="100%">{this.props.quip}</p>
            </Col>
          </Row>
        </Container>
      </Col>
    );
  }
}
