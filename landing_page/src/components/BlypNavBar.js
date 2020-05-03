import React from "react";
import { Navbar, Nav } from "react-bootstrap";

/**
 * Navbar with Blyp information
 */
export default class BlypNavBar extends React.Component {
  render() {
    return (
      <Navbar expand="sm" sticky="top" className="nagivation" >
        <Navbar.Brand className="blyp-logo" href="#home">Blyp</Navbar.Brand>
        <Navbar.Toggle />
        <Navbar.Collapse className="justify-content-end">
          <Nav>
            <Nav.Link href="#">about</Nav.Link>
            <Nav.Link href="#">support</Nav.Link>
            <Nav.Link href="#">team</Nav.Link>
          </Nav>
        </Navbar.Collapse>
      </Navbar>
    );
  }
}