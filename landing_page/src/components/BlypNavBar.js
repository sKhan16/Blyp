import React from "react";
import { Navbar, Nav } from "react-bootstrap";

/**
 * Navbar with Blyp information
 */
export default class BlypNavBar extends React.Component {
  render() {
    return (
      <Navbar expand="lg" className="bg-light">
        <Navbar.Brand href="#home">Blyp</Navbar.Brand>
        <Navbar.Toggle />
        <Navbar.Collapse className="justify-content-end">
          <Nav>
            <Nav.Link href="#">About</Nav.Link>
            <Nav.Link href="#">Support Blyp</Nav.Link>
            <Nav.Link href="#">Our Team</Nav.Link>
          </Nav>
        </Navbar.Collapse>
      </Navbar>
    );
  }
}