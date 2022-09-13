// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"cloud.google.com/go/storage"
	"golang.org/x/oauth2/google"
	"google.golang.org/api/compute/v1"
	"google.golang.org/api/iterator"
	kmspb "google.golang.org/genproto/googleapis/cloud/kms/v1"
	kms "cloud.google.com/go/kms/apiv1"
)

func main() {
	log.Print("starting server...")
	http.HandleFunc("/", handler)

	// Determine port for HTTP service.
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
		log.Printf("defaulting to port %s", port)
	}

	// Start HTTP server.
	log.Printf("listening on port %s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}

func handler(w http.ResponseWriter, r *http.Request) {
	// Compute Regions test
	name := os.Getenv("NAME")
	if name == "" {
		name = "World"
	}
	fmt.Fprintf(w, "Hello %s!\n", name)
	regions, err := listComputeRegions(w)
	if err != nil {
		log.Printf("Error listing compute regions: %s.", err.Error())
		fmt.Errorf(err.Error())
	}
	fmt.Fprintf(w, "Regions: %v!\n", regions)
	log.Println("Regions: %v!\n", regions)

	// Buckets test
	buckets, err := listBuckets(w)
	if err != nil {
		log.Printf("Error listing project buckets: %s.", err.Error())
		fmt.Errorf(err.Error())
	}
	log.Println("Buckets: %v!\n", buckets)
	fmt.Fprintf(w, "Buckets: %v!\n", buckets)

	// KMS test
	keyrings, err := listKeyRings(w)
	if err != nil {
		log.Printf("Error listing project keyrings: %s.", err.Error())
		fmt.Errorf(err.Error())
	}
	log.Println("Keyrings: %v!\n", keyrings)
	fmt.Fprintf(w, "Keyrings: %v!\n", keyrings)
}

func listBuckets(w http.ResponseWriter) ([]string, error) {
	projectID := os.Getenv("PROJECT_ID")
	ctx := context.Background()
	log.Println("Creating Client for Storage.")
	client, err := storage.NewClient(ctx)
	if err != nil {
		return nil, fmt.Errorf("storage.NewClient: %v", err)
	}
	defer client.Close()

	ctx, cancel := context.WithTimeout(ctx, time.Second*30)
	defer cancel()

	var buckets []string
	log.Println("Getting buckets in project.")
	it := client.Buckets(ctx, projectID)
	for {
		battrs, err := it.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			return nil, err
		}
		buckets = append(buckets, battrs.Name)
	}
	return buckets, nil
}

func listComputeRegions(w http.ResponseWriter) ([]string, error) {
	ctx := context.Background()

	log.Println("Creating Default Client for Compute client.")
	c, err := google.DefaultClient(ctx)
	if err != nil {
		log.Fatal(err)
	}

	log.Println("Creating service for Compute client.")
	computeService, err := compute.New(c)
	if err != nil {
		log.Fatal(err)
	}

	// Project ID for this request.
	project := os.Getenv("PROJECT_ID")
	var regions []string
	log.Println("Getting compute regions.")
	req := computeService.Regions.List(project)
	if err := req.Pages(ctx, func(page *compute.RegionList) error {
		for _, region := range page.Items {
			// TODO: Change code below to process each `region` resource:
			regions = append(regions, region.Name)
		}
		return nil
	}); err != nil {
		log.Fatal(err)
		return nil, err
	}
	return regions, nil
}

func listKeyRings(w http.ResponseWriter) ([]string, error) {
	securityProjectID := os.Getenv("SECURITY_PROJECT_ID")
	locationID := "global"

	log.Println("Creating service for KMS client.")
	ctx := context.Background()
	client, err := kms.NewKeyManagementClient(ctx)
	if err != nil {
		log.Fatalf("Failed to setup client: %v", err)
	}
	defer client.Close()

	log.Println(fmt.Sprintf("Creating request for KMS client on project: %s and location: %s", securityProjectID, locationID))
	listKeyRingsReq := &kmspb.ListKeyRingsRequest{
		Parent: fmt.Sprintf("projects/%s/locations/%s", securityProjectID, locationID)
	}

	it := client.ListKeyRings(ctx, listKeyRingsReq)

	var keyrings []string
	for {
		resp, err := it.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			log.Fatalf("Failed to list key rings: %v", err)
		}

		keyrings = append(keyrings, resp.Name)
	}

	return keyrings, nil
}
