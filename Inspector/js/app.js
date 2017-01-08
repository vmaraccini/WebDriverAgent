/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

import React from 'react';

import HTTP from 'js/http';
import Screen from 'js/screen';
import ScreenshotFactory from 'js/screenshot_factory';
import Tree from 'js/tree';
import TreeNode from 'js/tree_node';
import TreeContext from 'js/tree_context';
import Inspector from 'js/inspector';

require('css/app.css')

const SCREENSHOT_ENDPOINT = 'screenshot-lowres';
const TREE_ENDPOINT = 'source';
const ORIENTATION_ENDPOINT = 'orientation';

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  componentDidMount() {
    var intervalID = setInterval(() => {
      this.fetchScreenshot();
    }, 400);
  }

  fetchScreenshot() {
    HTTP.get(SCREENSHOT_ENDPOINT, (base64EncodedImage) => {
      ScreenshotFactory.createScreenshot('PORTRAIT', base64EncodedImage, (screenshot) => {
        this.setState({
          screenshot: screenshot,
        });
      });
    });
  }

  tapPoint(x, y) {
    HTTP.post(TAP_ENDPOINT, {'x': x, 'y': y}, (x, y) => {});
  }

  render() {
    return (
  		<div id="app">
  			<Screen
          highlightedNode={this.state.highlightedNode}
          screenshot={this.state.screenshot}
          rootNode={this.state.rootNode} />
  		</div>
    );
  }
}

React.render(<App />, document.body);
