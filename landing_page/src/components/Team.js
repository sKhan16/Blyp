import React from "react";
import { Jumbotron, Row, Container } from "react-bootstrap";
import PersonCard from "./PersonCard";

import gravatar from "../img/gravatar.png";

export default class Team extends React.Component {
  render() {
    return (
      <Jumbotron className="bg-white text-left pt-0">
        <h2 className="display-4 font-weight-bold">Our Team</h2>
        <Container>
          <Row>
            <PersonCard
              imgSrc={gravatar}
              name="Hayden Hong"
              role="iOS Developer"
              email="hello@haydenhong.com"
              quip="Hello world!"
            ></PersonCard>
            <PersonCard
              imgSrc={gravatar}
              name="Vanely Ruiz"
              role="Designer & Developer"
              email="vanely@uw.edu"
              quip="Hello world!"
            ></PersonCard>
            <PersonCard
              imgSrc={gravatar}
              name="Shakeel Khan"
              role="Full Stack Developer"
              email="khansk97@uw.edu"
              quip="Hello world!"
            ></PersonCard>
            <PersonCard
              imgSrc={gravatar}
              name="Kassandra Franco"
              role="PM & Designer"
              email="kfranco@uw.edu"
              quip="Hello world!"
            ></PersonCard>
          </Row>
        </Container>
      </Jumbotron>
    );
  }
}
