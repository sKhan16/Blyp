import React from "react";
/**
 * Navbar with Blyp information
 */
export default class BlypNavBar extends React.Component {
  render() {
    return (
        <nav className="navigation">
            <div className="blyp-logo">
                
                <a className="nav-link blyp-text-logo" href="#headline" alt="link to Blyp's home page">Blyp</a>
            </div>

        <ul className="nav-bar">
            <li><a className="nav-link" href="#about" alt="link to about section">about</a></li>
            <li><a className="nav-link" href="#purpose" alt="link to purpose section">purpose</a></li>
            <li><a className="nav-link" href="#support" alt="link to support section">support</a></li>
            <li><a className="nav-link" href="#team" alt="link to team section">team</a></li>
        </ul>
      {/* <Navbar expand="sm" sticky="top" className="nagivation" >
        <Navbar.Brand className="blyp-logo" href="#home">Blyp</Navbar.Brand>
        <Navbar.Toggle />
        <Navbar.Collapse className="justify-content-end">
          <Nav>
            <Nav.Link href="#">about</Nav.Link>
            <Nav.Link href="#">support</Nav.Link>
            <Nav.Link href="#">team</Nav.Link>
          </Nav>
        </Navbar.Collapse>
      </Navbar> */} 
      </nav>
    );
  }
}