import json
import requests

import unittest2 as unittest


class TestLauncher(unittest.TestCase):

    def test_basic(self):
        data = json.dumps({'application': 'basic'})
        req = requests.post(
            'http://localhost:8080/vtk',
            data=data
        )
        self.assertTrue(req.ok)
        resp = req.json()
        self.assertIn('id', resp)
        self.assertIn('sessionURL', resp)
        self.assertNotIn('error', resp)

        req = requests.get(
            'http://localhost:8080/vtk/' + resp['id']
        )
        self.assertTrue(req.ok)
        stat = req.json()
        self.assertNotIn('error', stat)
        self.assertEqual(stat['id'], resp['id'])

        req = requests.delete(
            'http://localhost:8080/vtk/' + resp['id']
        )
        self.assertNotEqual(req.status_code, 404)

        req = requests.get(
            'http://localhost:8080/vtk/' + resp['id']
        )
        self.assertFalse(req.ok)

    def test_bad_application(self):
        req = requests.post(
            'http://localhost:8080/vtk',
            data='{"application": "unknown"}'
        )
        self.assertFalse(req.ok)

    def test_start_fail(self):
        req = requests.post(
            'http://localhost:8080/vtk',
            data='{"application": "fail"}'
        )
        self.assertIn('error', req.json())

    def test_start_timeout(self):
        req = requests.post(
            'http://localhost:8080/vtk',
            data='{"application": "timeout"}'
        )
        self.assertIn('error', req.json())

if __name__ == '__main__':
    unittest.main()
