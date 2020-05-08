import React from "react";

export default class Headline extends React.Component {
  render() {
    return (
      <div id="headline" className="section headline-container">
      <h1 className="header">curate your <br></br> digital self.</h1>
        <p className="subheader">with <span className="blyp-text-logo">Blyp</span>, you can share your experiences with loved ones</p>
        
        <a className="button button-temp" href="blyp.info">coming soon to the app store</a>
        
        {/* <div className="download-button">  
            <a href="" alt="Download in the app store link"> </a>
        </div> */}
            
      </div>
    );
  }
}